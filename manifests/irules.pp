# == Class: profile_f5_ltm::irules
# Creates irules for each role in roles_to_lb
class profile_f5_ltm::irules {
  # Wraps the f5_irule type, pretty straightforward:
  # https://forge.puppet.com/puppetlabs/f5/readme#f5_irule
  # The data in hiera will be passed into a call to create_resources()
  # use the keys of roles_to_lb, which are role names
  $profile_f5_ltm::roles_to_lb.keys.each | $role | {
    $irule = $profile_f5_ltm::roles_to_lb[$role][irule]
    validate_hash($irule)
    create_resources(f5_irule,$irule)
  }
}
