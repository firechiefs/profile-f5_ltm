# == Class: profile_f5_ltm
#
# Wraps the puppetlabs/f5 module to create a load balanced application of a role
#
# given a role to LB, this module performs a puppetdb query to find nodes that
# match the given role string.  The node's name and IP will be returned as part
# of the query.

# It attempts to create a load balanced vip, which implies this order:
# Nodes     ->
# Monitors  ->
# Pools     ->
# VIP       ->

# === Parameters
#
# [*roles_to_lb*]
# A hash of of roles, the outer key being the 'role' name to lookup via puppetdb


# Dependencies: puppetlabs/f5, puppetlabs/stdlib, dalen/puppetdbquery
# == Class: profile_f5_ltm
#
class profile_f5_ltm {
  # TODO: (rmarin), this might better be an APL lookup in hiera
  # Though the lookup type is priority only, which means you cannot do a merge
  # only the most specific values get returned:
  # https://docs.puppet.com/hiera/3.1/puppet.html#automatic-parameter-lookup
  # Priority Only
  # Limitations
  # Automatic parameter lookup can only use the priority lookup method.
  # This means that, although it can receive any type of data from Hiera
  # (strings, arrays, hashes), it cannot merge values from multiple hierarchy
  # levels; you will only get the value from the most-specific hierarchy level.
  $cfg = hiera('profile_f5_ltm')
  $roles_to_lb = $cfg[roles_to_lb]

  # Anchor pattern to contain dependencies
  anchor { 'profile_f5_ltm::begin': } ->
  class { 'profile_f5_ltm::nodes': } ->
  class { 'profile_f5_ltm::monitors': } ->
  class { 'profile_f5_ltm::pools': } ->
  class { 'profile_f5_ltm::irules': } ->
  class { 'profile_f5_ltm::vip': } ->
  anchor { 'profile_f5_ltm::end': }
}
