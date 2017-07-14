require 'spec_helper'

RSpec.describe JWTGenerator do
  subject do
    klass = described_class.new
    expect(klass).to receive_messages(prompt: test_prompt)
    klass
  end

  let(:test_prompt) { TTY::TestPrompt.new(prefix: '[?] ', active_color: :cyan, help_color: :red) }
  let(:jwt_token) do
    JWT.encode(
      {
        'user_id' => '123',
        'email'   => 'foo@bar.com',
        'cvv'     => '333'
      },
      ENV.fetch('SECRET'),
      'HS256'
    )
  end

  before do
    test_prompt.input << "123\r"
    test_prompt.input << "foo@bar.com\r"
    test_prompt.input << "yes\r"
    test_prompt.input << "cvv\r"
    test_prompt.input << "333\r"
    test_prompt.input << "no\r"
    test_prompt.input.rewind

    subject.call
  end

  describe 'questions' do
    it 'asks right chain of questions' do
      # p test_prompt.output.string
      expect(test_prompt.output.string).to eq([
        "[?] Enter user_id \e[2K\e[1G",
        "[?] Enter user_id 1\e[2K\e[1G",
        "[?] Enter user_id 12\e[2K\e[1G",
        "[?] Enter user_id 123\e[2K\e[1G",
        "[?] Enter user_id 123\n\e[1A\e[2K\e[1G",
        "[?] Enter user_id \e[36m",
        "123\e[0m\n",

        "[?] What is your email? \e[2K\e[1G",
        "[?] What is your email? f\e[2K\e[1G",
        "[?] What is your email? fo\e[2K\e[1G",
        "[?] What is your email? foo\e[2K\e[1G",
        "[?] What is your email? foo@\e[2K\e[1G",
        "[?] What is your email? foo@b\e[2K\e[1G",
        "[?] What is your email? foo@ba\e[2K\e[1G",
        "[?] What is your email? foo@bar\e[2K\e[1G",
        "[?] What is your email? foo@bar.\e[2K\e[1G",
        "[?] What is your email? foo@bar.c\e[2K\e[1G",
        "[?] What is your email? foo@bar.co\e[2K\e[1G",
        "[?] What is your email? foo@bar.com\e[2K\e[1G",
        "[?] What is your email? foo@bar.com\n\e[1A\e[2K\e[1G",
        "[?] What is your email? \e[36m",
        "foo@bar.com\e[0m\n",

        "[?] Any additional inputs? \e[31m(yes/No)\e[0m \e[2K\e[1G",
        "[?] Any additional inputs? \e[31m(yes/No)\e[0m y\e[2K\e[1G",
        "[?] Any additional inputs? \e[31m(yes/No)\e[0m ye\e[2K\e[1G",
        "[?] Any additional inputs? \e[31m(yes/No)\e[0m yes\e[2K\e[1G",
        "[?] Any additional inputs? \e[31m(yes/No)\e[0m yes\n\e[1A\e[2K\e[1G",
        "[?] Any additional inputs? \e[36myes\e[0m\n",

        "[?] Enter key \e[2K\e[1G[?] Enter key c\e[2K\e[1G",
        "[?] Enter key cv\e[2K\e[1G[?] Enter key cvv\e[2K\e[1G",
        "[?] Enter key cvv\n\e[1A\e[2K\e[1G",
        "[?] Enter key \e[36mcvv\e[0m\n",

        "[?] Enter value for \"cvv\" \e[2K\e[1G",
        "[?] Enter value for \"cvv\" 3\e[2K\e[1G",
        "[?] Enter value for \"cvv\" 33\e[2K\e[1G",
        "[?] Enter value for \"cvv\" 333\e[2K\e[1G",
        "[?] Enter value for \"cvv\" 333\n\e[1A\e[2K\e[1G",
        "[?] Enter value for \"cvv\" \e[36m333\e[0m\n",

        "[?] Any additional inputs? \e[31m(yes/No)\e[0m \e[2K\e[1G",
        "[?] Any additional inputs? \e[31m(yes/No)\e[0m n\e[2K\e[1G",
        "[?] Any additional inputs? \e[31m(yes/No)\e[0m no\e[2K\e[1G",
        "[?] Any additional inputs? \e[31m(yes/No)\e[0m no\n\e[1A\e[2K\e[1G",
        "[?] Any additional inputs? \e[36mno\e[0m\n"
      ].join)
    end

    describe 'clipboard' do
      it 'saves token in clipboard' do
        expect(Clipboard.paste).to eq(jwt_token)
      end
    end
  end
end
