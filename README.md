# PURPOSE:

deploys a load balanced 'role(s)' of servers on an F5

*(nodes, monitors, pools, irules and vips)*

# HIERA DATA:
Assuming a role fact of 'puhprxs'
The basic structure is as follows:

```
profile_f5_ltm:
  roles_to_lb:
    puhprxs:
      partition: '/some_partition'
      listening_port: 80
      monitor:
        hash:
          .... monitor options
      irule:
        hash:
          ... irule options
      pool:
        hash:
          ... pool options
      vip:
        hash:
          .... vip options
```

The partition key under the role name controls the partition where *_nodes_* are created on the F5

The listening_port key under the role name controls the port that members in *_pools_* will listen on.

All other settings are controlled under the appropriate areas.  Pool options under pool, and vip options under vip, etc.  These options map to parameters on the puppetlabs-f5 types.  Any valid combination of settings and values you can provide to their types can be defined here.  See this documentation for more detail:
https://forge.puppet.com/puppetlabs/f5

To exclude any portion of the stack from being built, simply place an empty hash under the key.
For example, to avoid creating an irule for a given role, the structure would look like:

```
      irule:
        {}
```

# HIERA EXAMPLE:

Here is a more fleshed out example.

```
profile_f5_ltm:
  roles_to_lb:
    puhprxs:
      partition: '/some_partition'
      listening_port: 80
      monitor:
        puhprxs:
          name: '/some_partition/puhprxs'
          parent_monitor: '/Common/http'
          ensure: 'present'
          provider: 'http'
      irule:
        puhprxs:
          definition: |
            when HTTP_REQUEST {
              if { [HTTP::uri] eq "/mytest" } {
                    log local0. "Hello World"
                    HTTP::respond 200 content "Hello World" "Content-Type" "text/xml"
                 }
              }
          ensure: 'present'
          name: '/INF/puhprxs_irule'
      pool:
        puhprxs:
          name: '/some_partition/puhprxs_pool'
          ensure: 'present'
          availability_requirement: 'all'
          description: 'The Puppet HTTP Proxy Pool'
          health_monitors: '/some_partition/puhprxs'
          # members: will be figured out by the pools.pp manifest
          load_balancing_method: 'round-robin'
      vip:
        puhprxs:
          description: 'HTTP Proxy served by squid'
          default_pool: '/some_partition/puhprxs_pool'
          ensure: 'present'
          name: '/some_partition/puhprxs_vip'
          protocol: 'tcp'
          provider: 'standard'
          state: 'enabled'
          service_port: 80
          destination_address: '10.10.10.1'
```


# MODULE DEPENDENCIES:
```
puppet module install puppetlabs-f5
puppet module install dalen-puppetdbquery
```

# USAGE:
## Puppetfile:
```
mod "puppetlabs-f5",                '1.5.0'
mod "dalen-puppetdbquery",          '2.1.1'

mod 'firechiefs-profile_f5_ltm',
  :git    => 'https://github.com/firechiefs/profile_f5_ltm',
  :tag    => '1.0.0'
```

## Manifests:
```
class role::*rolename* {
  include profile_f5_ltm
}
```

# Misc
The following classes wrap f5 types in a call to create_resources() with your hiera data:
- irules
- monitors
- vip

The classes *_nodes_* and *_pools_* are different.

The classes nodes and pools utilize the role name as input into a puppetdb query.
The resulting query feeds back information used to dynamically create new nodes and new pool members as they appear in puppet db.  As of 1.0.0 you do not have control over the nodes that are created, nor the members in a pool.  If you supply a role to load balance, then all servers in that role will appear as nodes, and as pool members if you declare the corresponding data in hiera.

This module uses an explicit ordering of class manifest application via the anchor pattern.

Class manifests are applied in this order:
- Nodes ->
- Monitors ->
- Pools ->
- Irules ->
- Vip
