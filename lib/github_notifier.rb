require 'octokit'
require 'jwt'

class GitHubNotifier

  def initialize(pull_request, surge_domain)
    @pull_request = pull_request
    @surge_domain = surge_domain
  end

  def notify
    client.add_comment(
      "alphagov/government-frontend",
      pull_request,
      "👉 view new visual regression tests at #{surge_domain}"
    )
  end

private

  def client
    client = Octokit::Client.new(bearer_token: jwt_token_signed_with_private_key)
    access_token = client.create_installation_access_token(ENV['GITHUB_INSTALLATION_ID']).token
    Octokit::Client.new(access_token: access_token)
  end

  def jwt_token_signed_with_private_key
    private_key = OpenSSL::PKey::RSA.new(ENV['GITHUB_APP_PRIVATE_KEY'])

    payload = {
      iat: Time.now.to_i,
      exp: Time.now.to_i + (10 * 60),
      iss: ENV['GITHUB_APP_ID'],
    }

    JWT.encode(payload, private_key, 'RS256')
  end
end
