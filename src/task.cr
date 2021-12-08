class Task
  def self.retry(limit = 10, backoff = nil)
    attempt = 1
    loop do
      begin
        return yield(attempt)
      rescue error
        raise error if attempt >= limit
        if backoff
          sleep backoff*attempt
        else
          sleep 0.1
        end
        attempt = attempt + 1
      end
    end
  end
end
