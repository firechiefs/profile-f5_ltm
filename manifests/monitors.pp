# == Class: profile_f5_ltm::monitors
# creates monitors for all specified roles_to_lb
class profile_f5_ltm::monitors {
  # similar pattern as nodes:
  # get all 'monitor' keys of a role to lb, and pass that hash into a
  # create_resources() call with the f5_monitor type

  $profile_f5_ltm::roles_to_lb.keys.each | $role | {
    debug("Creating Resource f5_monitor with data: ${monitor}")
    $monitor = $profile_f5_ltm::roles_to_lb[$role][monitor]
    create_resources(f5_monitor,$monitor)

  }
}
