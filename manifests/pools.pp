# == Class: profile_f5_ltm::pools
# creates pools for all specified roles_to_lb
class profile_f5_ltm::pools {
  # similar pattern as nodes:
  # get all 'pool' keys of a role to lb, and pass that hash into a
  # create_resources() call with the f5_pool type
  # The Members attribute on f5_pool requires:
  # An array of hashes containing pool node members and their port. Pool members
  # must exist on the F5 before you classify them in f5_pool. You can create the
  # members using the f5_node type first. (See the example in Usage.)
  #
  # Valid options: 'none' or
  # [
  #   {
  #     'name' => '/PARTITION/NODE NAME',
  #     'port' => <an integer between 0 and 65535>,
  #   },
  #   ...
  # ]

  $profile_f5_ltm::roles_to_lb.keys.each | $role | {
    $pool_hash = $profile_f5_ltm::roles_to_lb[$role][pool]

    $port = $pool_hash[$role][listening_port]
    $partition = $profile_f5_ltm::roles_to_lb[$role][partition]

    # usage: generate_members_hash_array("puhprxs",80,"/INF")
    $getmembers = generate_members_hash_array($role,$port,$partition)

    $swapadizzle = {members => $getmembers}

    $pool_options = merge($pool_hash[$role], $swapadizzle)

    Notify {'merge output':
      message => $pool_options
    }



  }
  Notify {'another test':
      message => "this is a test inside f5_ltm_pools"
    }
  Notify {'testing':
      message => "${test}"
    }
}
