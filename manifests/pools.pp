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

  $test = generate_members_hash_array(["puhprx",80,"/INF"])
  Notify {'testing':
      message => $test
    }
}
