# == Class: profile_f5_ltm::nodes
#
class profile_f5_ltm::nodes {
  if !empty($profile_f5_ltm::roles_to_lb) {
    # iterate over every role and do a puppet db query to get the nodes:
    $profile_f5_ltm::roles_to_lb.keys.each | $role | {
      # puppet db query to find nodes where the role fact is our role,
      # and returning a hash of nodes containing hostname/ipaddress:
      # {
      #   "foo.example.com": {
      #     "hostname": "foo",
      #     "ipaddress": "192.168.0.2",
      #   },
      #   "bar.example.com": {
      #     "hostname": "bar",
      #     "ipaddress": "192.168.0.3",
      #   }
      # }
      $nodes = query_facts("role=${role}",['hostname', 'ipaddress'])
      # iterate over every node to create it on the f5
      $nodes.keys.each | $node | {
        # f5_node  {'/Common/WWW_Server_1':
        # ensure                   => 'present',
        # address                  => '172.16.226.10',
        # description              => 'WWW Server 1',
        # availability_requirement => 'all',
        # health_monitors          => ['/Common/icmp'],
        # }

        $partition = $profile_f5_ltm::roles_to_lb[$role][partition]
        $address = $nodes[$node][ipaddress]
        $description = $nodes[$node][hostname]

        f5_node {"${partition}/${node}":
          ensure          => 'present',
          address         => $address,
          description     => $description,
          health_monitors => 'default',
        }
      }
    }
  }
}
