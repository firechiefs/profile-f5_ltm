
module Puppet::Parser::Functions
  newfunction(:generate_members_hash_array, :type => :rvalue) do |args|
    # first arg is the role to lookup in puppetdb
    # second arg is the port
    # we will try to combine the hostnames and port into an array of hashes
    # ala this format:
    # [
    #   {
    #     'name' => '/PARTITION/NODE NAME',
    #     'port' => <an integer between 0 and 65535>,
    #   },
    #   ...
    # ]

    # arguments to variables
    role = args[0]
    port = args[1]
    partition = args[2]


    # the empty hash array to insert into
    hash_array = []

    # this is a call to query_nodes in puppetdbquery, but is prefixed with
    # 'function_' as per puppetlabs usage spec for calling external functions.
    # https://docs.puppet.com/guides/custom_functions.html
    # don't believe their lies, the brackets is intended for calls in this
    # function, not 'puppet' code manifests
    # nodes_array = function_query_nodes(["role=#{role}"])
    nodes_array = query_nodes("role=#{role}")

    # loop over every returned node, make a hash of the name and port
    # add it into the empty array
    nodes_array.each do |node|
      hash_array.push('name' => "#{partition}/#{node}", 'port' => port)
    end
    return hash_array
  end
end
