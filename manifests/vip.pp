# == Class: profile_f5_ltm::vip
# creates virtual servers for all roles_to_lb
class profile_f5_ltm::vip {
  # This wraps the f5_virtualserver type, which is a very complicated type:
  # https://forge.puppet.com/puppetlabs/f5/readme#f5_virtualserver
  # There are combinations of features that are only available with certain
  # 'providers'
  # See the providers and features blurb in the above link for valid combntns
  # our use case, probably, is within the 'standard' provider.
  # All the magic happens in the f5_virtualserver type
  # We are only passing the options via hiera via create_resources

  # use the keys of roles_to_lb, which are role names
  $profile_f5_ltm::roles_to_lb.keys.each | $role | {
    $virtual_server = $profile_f5_ltm::roles_to_lb[$role][vip]
    validate_hash($virtual_server)
    create_resources(f5_virtualserver,$virtual_server)
  }

}
