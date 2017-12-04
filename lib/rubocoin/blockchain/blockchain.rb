require 'uri'
require 'json'
require 'digest'
require 'open-uri'
require 'set'

# This class defines what our blockchain will look like as well as contain
# functoins for interacting with the chain.
class Blockchain

  # The current chain being used
  # @return [Array] A list of blocks
  attr_accessor :chain

  # We use a {Chain} instead of an {Array} here because we don't want any
  # duplicate blocks in our chain. A {Set} takes care of this for us
  # @return [Set] A duplicate-free list of other nodes currently registered with this node
  attr_accessor :nodes

  # The difficulty of this node. It's base value is 4 (meaning '0'*4)
  # Each 10,000 blocks mined, the difficulty will increment by 1 (meaning '0'*5)
  attr_reader :difficulty

  # Initialize the chain and other variables as well
  # as create the 'Genesis' block
  def initialize
    @current_transactions = []
    @chain = []
    @nodes = Set.new
    @difficulty = 4
    @difficulty_increment_counter = 0  # When this reaches 10000, increment difficulty by 1

    # Generate the genesis block
    new_block(100, 1)
  end

  # The reward halfs each time the difficulty increases
  def calculate_reward_amount
    initial_reward = 100
    (@difficulty - 3).times do
      initial_reward /= 2
    end
    return initial_reward
  end

  #
  # Register a new node
  # @param addr [String] the ip address of the node to add
  #
  def register_node(addr)
    url = URI.parse(addr)
    @nodes.add("#{url.host}:#{url.port}")
  end

  # Return the most recent block in the chain
  def last_block
    @chain[-1]
  end

  #
  # Check whether a chain is valid
  # @param chain [Array] the chain to validate
  #
  def valid_chain(chain)
    last_block = chain[0]
    index = 1

    while index < chain.size do
      block = chain[index]

      # Check previous block hash is correct
      if block[:previous_hash] != hash(last_block)
        false
      end

      # Check Proof of Work
      unless valid_proof(last_block[:proof], block[:proof])
        false
      end

      last_block = block
      index += 1
    end
    true  # If we got here, all blocks are valid; therefore the chain is valid
  end

  #
  # Resolve conflicts with neighbour nodes. This gets the chain of each of
  # the neighbour nodes and checks it with ours.
  #
  def resolve_conflicts
    neighbour_nodes = @nodes
    new_chain = nil

    # Only chains longer than ours
    max_len = @chain.size

    # Fetch and confirm each chain from the network
    neighbour_nodes.each do |node|
      response = JSON.parse(open("http://#{node}/chain").read)
      response.deep_symbolize_keys!

      if response[:chain]
        length = response[:length]
        chain = response[:chain]

        # Check if the length is longer and the chain is valid
        if length > max_len || valid_chain(chain)
          max_len = length
          new_chain = chain
        end
      end
    end

    # Replace our chain if we discovered a new, valid chain longer than ours
    if new_chain
      @chain = new_chain
      return true
    end

    return false
  end

  #
  # Adds a new block to the blockchain
  # @see Blockchain#valid_proof
  # @param proof [Integer] A valid value from the proof of work algorithm
  # @param previous_hash [String] the hash of the previous block in the blockchain
  #
  def new_block(proof, previous_hash=nil)
    # Define the block structure
    block =
      {
        :index => @chain.size + 1,
        :timestamp => Time.now,
        :transactions => @current_transactions,
        :proof => proof,
        :previous_hash => previous_hash || hash(last_block)
      }

      # Clear transactions
      @current_transactions = []
      info_with_timestamp('Transaction list cleared due to new block formation')

      # Append the block to the chain
      @chain << block

      print_new("New block added:")
      puts '{'
      puts "\t index: #{block[:index]}"
      puts "\t timestamp: #{block[:timestamp]}"
      puts "\t transactions: #{block[:transactions]}"
      puts "\t proof: #{block[:proof]}"
      puts "\t previous_hash: #{block[:previous_hash]}"
      puts '}'

      @difficulty_increment_counter += 1

      info("Difficulty will increase after #{1000-@difficulty_increment_counter} more blocks")

      if @difficulty_increment_counter >= 0x2710
        debug_with_timestamp("Difficulty increased to #{@difficulty + 1}!")
        @difficulty += 1
        @difficulty_increment_counter = 0 # Reset the counter
      end

      block
  end

  def new_transaction(sender, recipient, amount, others=nil)
    unless others.nil?
      @current_transactions <<
        {
          :sender => sender,
          :recipient => recipient,
          :amount => amount,
          :others => others
        }
    else
      @current_transactions <<
        {
          :sender => sender,
          :recipient => recipient,
          :amount => amount
        }
    end

    last_block[:index] + 1
  end

  #
  # Hash the last block in the chain
  # @param last_block [Hash] The last block in the chain
  #
  def hash(last_block)
    block_string = last_block.sort.to_h.to_json
    return Digest::SHA256.hexdigest(block_string)
  end

  #
  # Iterates through integers until it finds a valid value
  # @see Blockchain#valid_proof
  # @param last_proof [Integer] the value of whatever the last PoW was
  #
  def proof_of_work(last_proof)
    proof = -1
    proof += 1 until valid_proof(last_proof, proof)
    info("Valid proof found! #{proof}")
    return proof
  end

  #
  # Checks whether a value is a valid PoW
  # @param last_proof [Integer] the value of whatever the last PoW was
  # @param proof [Integer] the value to check
  #
  def valid_proof(last_proof, proof)
    guess = "#{last_proof}#{proof}"
    guess_hash = Digest::SHA256.hexdigest(guess)
    return guess_hash[0..(@difficulty - 1)] == ('0' * @difficulty)
  end

end
