# == Class: profile_f5_ltm::monitors
# creates monitors for all specified roles_to_lb
class profile_f5_ltm::monitors {
  # similar pattern as nodes:
  # get all 'monitor' keys of a role to lb, and pass that hash into a
  # create_resources() call with the f5_monitor type

  $test = generate_members_hash_array("puhprx",80,"/INF")
  Notify {'testing':
      message => $test
    }
}
