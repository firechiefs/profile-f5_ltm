# == Class: profile_f5_ltm::pools
# creates pools for all specified roles_to_lb
class profile_f5_ltm::pools {
  # similar pattern as nodes:
  # get all 'pool' keys of a role to lb, and pass that hash into a
  # create_resources() call with the f5_pool type
  $profile_f5_ltm::roles_to_lb.keys.each | $role | {
    $monitor = $profile_f5_ltm::roles_to_lb["${role}"][monitor]
    validate_hash($monitor)
    create_resources(f5_monitor,$monitor)

  }

}
