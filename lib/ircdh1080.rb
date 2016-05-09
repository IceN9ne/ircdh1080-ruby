require "ircdh1080/version"
require "ircdh1080/base64"

require "openssl"

class IrcDH1080
  # @return [String] Our public key pre-encoded for sending to others
  attr_reader :pub_key

  # Initializes the DH1080 object
  # @note The public/private keys are randomly generated with each call of IrcDH1080.new and remains the same for the duration of the object
  def initialize
    # p = 0xFBE1022E23D213E8ACFA9AE8B9DFADA3EA6B7AC7A7B7E95AB5EB2DF858921
    #       FEADE95E6AC7BE7DE6ADBAB8A783E7AF7A7FA6A2B7BEB1E72EAE2B72F9FA2
    #       BFB2A2EFBEFAC868BADB3E828FA8BADFADA3E4CC1BE7E8AFE85E9698A783E
    #       B68FA07A77AB6AD7BEB618ACF9CA2897EB28A6189EFA07AB99A8A7FA9AE29
    #       9EFA7BA66DEAFEFBEFBF0B7D8B
    # g = 2
    # 1080bit

    # The p and g used in the IRC DH1080 protocol stored in pem format to speed
    # up Diffie-Hellman initialization
    pem = "-----BEGIN DH PARAMETERS-----\n"                                    \
          "MIGOAoGIAPvhAi4j0hPorPqa6LnfraPqa3rHp7fpWrXrLfhYkh/q3pXmrHvn3mrb\n" \
          "q4p4Pnr3p/pqK3vrHnLq4rcvn6K/sqLvvvrIaLrbPoKPqLrfraPkzBvn6K/oXpaY\n" \
          "p4PraPoHp3q2rXvrYYrPnKKJfrKKYYnvoHq5mop/qa4pnvp7pm3q/vvvvwt9iwIB\n" \
          "Ag==\n"                                                             \
          "-----END DH PARAMETERS-----\n"

    @dh = OpenSSL::PKey::DH.new pem
    @dh.generate_key!

    # Store the public key pre-encoded. This is what we send to others.
    @pub_key = IrcDH1080::Base64.encode(@dh.pub_key.to_s(2))
  end

  # Computes the shared secret key
  # @param key [String] the base64 encoded key sent by the other user
  # @return [String] the shared secret key
  def compute_key(key)
    peer_key = OpenSSL::BN.new(IrcDH1080::Base64.decode(key), 2)
    secret = @dh.compute_key(peer_key)
    IrcDH1080::Base64.encode(OpenSSL::Digest::SHA256.digest(secret))
  end
end
