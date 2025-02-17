# frozen_string_literal: true

# The following code is dummy for document generation.

# llama_cpp.rb provides Ruby bindings for the llama.cpp.
module LLaMACpp
  # LLaMA file version.
  LLAMA_FILE_VERSION = '1'

  # LLaMA file magic.
  LLAMA_FILE_MAGIC = '0x67676a74'

  # LLaMA file magic unversioned.
  LLAMA_FILE_MAGIC_UNVERSIONED = '0x67676d6c'

  # LLaMA model file type.
  LLAMA_FTYPE_ALL_F32 = 0

  # LLaMA model file type.
  LLAMA_FTYPE_MOSTLY_F16  = 1

  # LLaMA model file type.
  LLAMA_FTYPE_MOSTLY_Q4_0 = 2

  # LLaMA model file type.
  LLAMA_FTYPE_MOSTLY_Q4_1 = 3

  # LLaMA model file type.
  LLAMA_FTYPE_MOSTLY_Q4_1_SOME_F16 = 4 # tok_embeddings.weight and output. weight are F16

  # LLaMA model file type.
  LLAMA_FTYPE_MOSTLY_Q4_2 = 5

  # LLaMA model file type.
  LLAMA_FTYPE_MOSTLY_Q4_3 = 6

  module_function

  # Quantizes the model.
  #
  # @param input_path [String] The path to the input model file.
  # @param output_path [String] The path to the output model file.
  # @param ftype [Integer] The file type.
  # @param n_threads [Integer] The number of threads.
  def model_quantize(input_path:, output_path:, ftype:, n_threads: 1); end

  # Returns the token id the beginning of sentence token.
  # @return [Integer]
  def token_bos; end

  # Returns the token id the end of sentence token.
  # @return [Integer]
  def token_eos; end

  # Prints system information.
  def print_system_info; end

  # Returns the flag for supporting mmap.
  # @return [Boolean]
  def mmap_supported?; end

  # Returns the flag for supporting mlock.
  # @return [Boolean]
  def mlock_supported?; end
end

# llama_cpp.rb provides Ruby bindings for the llama.cpp.
module LLaMACpp
  # Class for context
  class Context
    # Create context.
    #
    # @param model_path [String] The path to the model file.
    # @param params [ContextParams] The parameters for context.
    def initialize(model_path: nil, params: nil); end

    # Evaluates the tokens.
    #
    # @param tokens [Array<Integer>] The tokens to be evaluated.
    # @param n_past [Integer] The number of past tokens.
    # @param n_tokens [Integer] The number of tokens to be evaluated.
    # @param n_threads [Integer] The number of threads.
    # @return [NilClass]
    def eval(tokens:, n_past:, n_tokens: nil, n_threads: 1); end

    # Returns the logits.
    #
    # @param text [String] The text to be tokenized.
    # @param n_max_tokens [Integer] The maximum number of tokens.
    # @param add_bos [Boolean] The flag to add the beginning of sentence token.
    # @return [Array<Integer>]
    def tokenize(text:, n_max_tokens: nil, add_bos: true); end

    # Returns the embeddings.
    #
    # @return [Array<Float>]
    def embeddings; end

    # Converts token id to string.
    #
    # @param token_id [Integer]
    # @return [String]
    def token_to_str(token_id) end

    # Samples token id along with top_p and top_k.
    #
    # @param last_n_token [Array<Integer>]
    # @param top_k [Integer]
    # @param top_p [Float]
    # @param temp [Float]
    # @param penalty [Float]
    # @return [Integer]
    def sample_top_p_top_k(last_n_token, top_k:, top_p:, temp:, penalty:); end

    # Returns the number of vocabulary.
    #
    # @return [Integer]
    def n_vocab; end

    # Returns the number of text context.
    #
    # @return [Integer]
    def n_ctx; end

    # Returns the number of embeddings.
    #
    # @return [Integer]
    def n_embd; end

    # Prints timings.
    #
    # @return [NilClass]
    def print_timings; end

    # Resets timings.
    #
    # @return [NilClass]
    def reset_timings; end

    # Deallocates context.
    #
    # @return [NilClass]
    def free; end

    # Returns whether the context is not load model.
    #
    # @return [Boolean]
    def empty?; end

    # Loads model.
    #
    # @param model_path [String] The path to the model file.
    # @param params [ContextParams] The parameters for context.
    def load(model_path:, params:); end

    # Applies LLoRa from file.
    #
    # @param lora_path [String] The path to the LoRA file.
    # @param base_model_path [String] The path to the base model file.
    # @param n_threads [Integer] The number of threads.
    def apply_lora_from_file(lora_path:, base_model_path: nil, n_threads: 1); end
  end

  # Class for parameters
  class ContextParams
    # Sets the number of text context
    # @param n_ctx [Integer]
    def n_ctx=(n_ctx); end

    # Returns the number of text context
    # @return [Integer]
    def n_ctx; end

    # Sets the number of part.
    # @param n_parts [Integer]
    def n_parts=(n_parts); end

    # Return the number of part.
    # @return [Integer]
    def n_parts; end

    # Sets the random seed.
    # @param seed [Integer]
    def seed=(seed); end

    # Return the random seed.
    # @return [Integer]
    def seed; end

    # Sets the flag for using fp16 for KV cache.
    # @param flag [Boolean]
    def f16_kev=(flag); end

    # Returns the flag for using fp16 for KV cache.
    # @return [Boolean]
    def f16_kev; end

    # Sets the flag to compute all logits.
    # @param flag [Boolean]
    def logits_all=(flag); end

    # Returns the flag to compute all logits.
    # @return [Boolean]
    def logits_all; end

    # Sets the flag to load only vocabulary.
    # @param flag [Boolean]
    def vocab_only=(flag); end

    # Returns the flag to load only vocabulary.
    # @return [Boolean]
    def vocab_only; end

    # Sets the flag to force system to keep model in memory.
    # @param flag [Boolean]
    def use_mlock=(flag); end

    # Returns the flag to force system to keep model in memory.
    # @return [Boolean]
    def use_mlock; end

    # Sets the flag for embedding mode only.
    # @param flag [Boolean]
    def embedding=(flag); end

    # Returns the flag for embedding mode only.
    # @return [Boolean]
    def embedding; end
  end
end
