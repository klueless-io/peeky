module Peeky
  module Example
    # Yard sample
    class YardSample
      # A read write1
      attr_accessor :a_read_write1

      # A read write2
      attr_accessor :a_read_write2

      # A read write3
      attr_accessor :a_read_write3

      # B reader1
      attr_reader :b_reader1

      # B reader2
      attr_reader :b_reader2

      # E looks like an attr reader
      attr_reader :e_looks_like_an_attr_reader

      # C writer1
      attr_writer :c_writer1

      # C writer2
      attr_writer :c_writer2

      # Alpha sort1
      def alpha_sort1
      end

      # Alpha sort2
      def alpha_sort2
      end

      # D do something method
      def d_do_something_method
      end

      # E method with required param
      #
      # @param first_name [String] first name (required)
      def e_method_with_required_param(first_name)
      end

      # F method with required param and optional param
      #
      # @param first_name [String] first name (required)
      # @param last_name [String] last name (optional)
      def f_method_with_required_param_and_optional_param(first_name, last_name = '')
      end

      # G method with required param and two optional params
      #
      # @param first_name [String] first name (required)
      # @param last_name [String] last name (optional)
      # @param age [String] age (optional)
      def g_method_with_required_param_and_two_optional_params(first_name, last_name = '', age = 21)
      end

      # H list of optional parameters
      #
      # @param command_args [Array<Object>] *command_args - list of command args
      def h_list_of_optional_parameters(*command_args)
      end

      # I method with two required params and list of optional params
      #
      # @param first_name [String] first name (required)
      # @param last_name [String] last name (required)
      # @param alias_names [Array<Object>] *alias_names - list of alias names
      def i_method_with_two_required_params_and_list_of_optional_params(first_name, last_name, *alias_names)
      end

      # J method with list of named arguments
      #
      # @param options [<key: value>...] **options - list of key/values
      def j_method_with_list_of_named_arguments(**options)
      end

      # K method with block
      #
      # @param code_block [Block] &code_block
      def k_method_with_block(&code_block)
      end

      # L method with key value param required
      #
      # @param name [String] name: <value for name> (required)
      def l_method_with_key_value_param_required(name:)
      end

      # N method with key value param required and optional key value
      #
      # @param last_name [String] last_name: <value for last name> (required)
      # @param salutation [String] salutation: <value for salutation> (optional)
      def n_method_with_key_value_param_required_and_optional_key_value(last_name:, salutation: 'Mr')
      end

      # P available?

      # @return [Boolean] true when p available?
      def p_available?
      end

      # Q danger will robinson!
      def q_danger_will_robinson!
      end

      # Z complex
      #
      # @param aaa [String] aaa (required)
      # @param bbb [String] bbb (optional)
      # @param ccc [Array<Object>] *ccc - list of ccc
      # @param ddd [String] ddd: <value for ddd> (required)
      # @param eee [String] eee: <value for eee> (optional)
      # @param fff [<key: value>...] **fff - list of key/values
      # @param ggg [Block] &ggg
      def z_complex(aaa, bbb = 1, *ccc, ddd:, eee: 1, **fff, &ggg)
      end
    end
  end
end
