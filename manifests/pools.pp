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

  # What a tangled web.
  # use the keys of roles_to_lb, which are role names
  $profile_f5_ltm::roles_to_lb.keys.each | $role | {
    # The pool hash is the hash of all f5_pool options for this role
    $pool_hash = $profile_f5_ltm::roles_to_lb[$role][pool]
    if !empty($pool_hash) {
      # the port members will be listening on in this pool
      $port = $profile_f5_ltm::roles_to_lb[$role][listening_port]

      # the partition the nodes resides in
      $partition = $profile_f5_ltm::roles_to_lb[$role][partition]

      # A call to this function requires the args: role, port, partition
      # and does a puppetdbquery, returning an array of hashes.
      # this format is needed for the members attribute of f5_pool.
      # usage: generate_members_hash_array("puhprxs",80,"/INF")
      $getmembers = generate_members_hash_array($role,$port,$partition)

      # A temporary variable so we can create a hash with a key called members
      # who's value is the output of the custom function above.
      # TODO:(rmarin) might be able to do this:
      # $tempvar = {members => (generate_members_hash_array(...))}
      $swapadizzle = {members => $getmembers}

      # The full set of options, including all of our members from above.
      # this is needed so we can pass this hash to f5_pool in create_resources
      $temp_pool_options = merge($pool_hash[$role], $swapadizzle)
      $pool_options = {pool => $temp_pool_options}

      # The magic of create_resources()
      create_resources(f5_pool,$pool_options)
    }
  }
}
