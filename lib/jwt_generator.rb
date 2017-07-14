class JWTGenerator
  class << self
    def call
      new.call
    end
  end

  def call
    puts pastel.on_green.bold('Starting with JWT token generation.')

    @payload = {}

    payload['user_id'] = ask_user_id
    payload['email']   = ask_email

    while more_inputs?
      key = prompt.ask('Enter key') do |question|
        question.validate(/[a-zA-Z0-9]+/, 'Invalid input')
      end

      value = prompt.ask("Enter value for \"#{key}\"")

      payload[key] = value
    end

    Clipboard.copy(encoded_payload)

    puts pastel.on_green('The JWT has been copied to your clipboard!')
  end

  private

  attr_reader :payload

  def pastel
    @pastel ||= Pastel.new
  end

  def prompt
    @prompt ||= TTY::Prompt.new
  end

  def ask_user_id
    prompt.ask('Enter user_id') do |question|
      question.validate(/[a-zA-Z0-9]+/, 'Invalid input')
    end
  end

  def ask_email
    prompt.ask('What is your email?') do |question|
      question.validate(/\A[\w\.]+@\w+\.\w+\Z/, 'Invalid email address')
    end
  end

  def more_inputs?
    prompt.yes?('Any additional inputs?') do |question|
      question.default  false
      question.positive 'yes'
      question.negative 'no'
    end
  end

  def encoded_payload
    JWT.encode(payload, ENV.fetch('SECRET'), 'HS256')
  end
end
