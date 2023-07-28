class CountWordsJob < ApplicationJob
  queue_as :default

  def perform(file)
    # open the file
    # parse it
    # count words
  end
end
