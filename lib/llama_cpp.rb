# frozen_string_literal: true

require_relative 'llama_cpp/version'
require_relative 'llama_cpp/llama_cpp'

# llama_cpp.rb provides Ruby bindings for the llama.cpp.
module LLaMACpp
  # Class alias to match interface of whispercpp gem.
  Params = ContextParams

  module_function

  # Generates sentences following the given prompt for operation check.
  #
  # @param context [LLaMACpp::Context] The context to use.
  # @param prompt [String] The prompt to start generation with.
  # @param n_predict [Integer] The number of tokens to predict.
  # @param n_threads [Integer] The number of threads.
  # @return [String]
  def generate(context, prompt, n_predict: 128, n_threads: 1) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    raise ArgumentError, 'context must be an instance of LLaMACpp::Context' unless context.is_a?(LLaMACpp::Context)
    raise ArgumentError, 'context must have loaded the model' if context.empty?
    raise ArgumentError, 'prompt must be a String' unless prompt.is_a?(String)

    spaced_prompt = " #{prompt}"
    embd_input = context.tokenize(text: spaced_prompt, add_bos: true)

    n_ctx = context.n_ctx
    raise ArgumentError, "prompt is too long #{embd_input.size} tokens, maximum is #{n_ctx - 4}" if embd_input.size > n_ctx - 4

    last_n_tokens = [0] * n_ctx

    embd = []
    n_consumed = 0
    n_keep = 10
    n_past = 0
    n_remain = n_predict
    repeat_last_n = 64
    n_batch = 512
    output = []

    while n_remain != 0
      unless embd.empty?
        if n_past + embd.size > n_ctx
          n_left = n_past - n_keep
          n_past = n_keep
          embd.insert(0, last_n_tokens[(n_ctx - (n_left / 2) - embd.size)...-embd.size])
        end

        context.eval(tokens: embd, n_past: n_past, n_threads: n_threads)
      end

      n_past += embd.size
      embd.clear

      if embd_input.size <= n_consumed
        start = n_ctx - repeat_last_n
        id = context.sample_top_p_top_k(
          last_n_tokens[start...(start + repeat_last_n)], top_k: 40, top_p: 0.95, temp: 0.80, penalty: 1.1
        )
        last_n_tokens.shift
        last_n_tokens.push(id)

        embd.push(id)
        n_remain -= 1
      else
        while embd_input.size > n_consumed
          embd.push(embd_input[n_consumed])
          last_n_tokens.shift
          last_n_tokens.push(embd_input[n_consumed])
          n_consumed += 1
          break if embd.size >= n_batch
        end
      end

      embd.each { |token| output << context.token_to_str(token) }

      break if !embd.empty? && embd[-1] == LLaMACpp.token_eos
    end

    output.join.delete_prefix(spaced_prompt).strip
  end
end
