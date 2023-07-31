class CountWordsJob < ApplicationJob
  queue_as :default

  require 'net/http'
  require 'uri'
  require 'nokogiri'
  require 'csv'
  require 'httparty'

  #require 'combine_pdf'
  require 'pdf/reader'
  #require 'net/http'

  def perform(text_file)

    job_request = JobRequest.find_by(text_file: text_file)
    job_request.update(status: "in progress")
    #extracting text and storing it into file.text_content
    file=text_file.file
    text_file.text_content = retrieve_text_content(file)
    text_file.save!

    #TODO: retrieve selected language and pass it into translate function (it will take 2 args), there will be base url and then append?

    translation = translate(text_file.text_content)

    job_request.update(results: translation)
    job_request.update(status: "finished")

  end

    #text_file.text_content
    # open the file
    # url = URI("https://fr.lipsum.com/feed/html")

    # http = Net::HTTP.new(url.host, url.port)
    # http.use_ssl = true

    # request = Net::HTTP::Post.new(url)
    # #headers   X-Readable-API-Key
    # request["content-type"] = 'application/x-www-form-urlencoded'
    # request["X-RapidAPI-Key"] = 'SIGN-UP-FOR-KEY'
    # request["X-RapidAPI-Host"] = 'word-count-api.p.rapidapi.com'
    # request.body = "text=%3CREQUIRED%3E"

    # response = http.request(request)
    # puts response.read_body


    # parse it
    # count words


private

  def retrieve_text_content(file)

    # text_content = ''
    text_content = ''
    # For CSV files
    if file.content_type == 'text/csv'
      csv_string = file.download
      csv_data = CSV.parse(csv_string)

      csv_data.each do |row|
        text_content += row.join(' ') + "\n"
      end
    end

    # For PDF files
    if file.content_type == 'application/pdf'
      file_url = url_for(file)
      #file.download
      pdf_text = ''
      #CombinePDF.load(file)
      io = open(file_url)
      reader = PDF::Reader.new(file)
      reader.pages.each { |page| pdf_text += page.text }
      text_content = Nokogiri::HTML(pdf_text).text
    end
    text_content
  end

  def translate(text)

    #call DeepL API
    api_key =ENV["DEEPL_KEY"]
    url = 'https://api-free.deepl.com/v2/translate'

    response = HTTParty.post(url,
      headers: {
        'Authorization' => "DeepL-Auth-Key #{api_key}",
        'Content-Type' => 'application/json'
      },
      body: {
        text: text.split,
        target_lang: "FR"
      }.to_json
    )

    if response.code == 200
      translation_array = JSON.parse(response.body)['translations']#[0]['text']
      translation = ""
      translation_array.each do |phrase|
        translation += " #{phrase['text']}"
      end
      return translation
    else
      # Handle API error
      puts "DeepL API call failed: #{response.code} - #{response.body}"
      return nil
    end












    # url = URI.parse('https://api-free.deepl.com/v2/translate')
    # data = {
    #   text: ["#{text_file.text_content}"],
    #   target_lang: 'FR'
    # }

    # http = Net::HTTP.new(url.host, url.port)
    # http.use_ssl = true

    # request = Net::HTTP::Post.new(url.path,
    #   'Content-Type' => 'application/json',
    #   'Authorization' => ENV["DEEPL_KEY"])

    # request.body = data.to_json

    # response = http.request(request)

    # if response.code == '200'
    # # Process the API response as needed
    #   api_response = JSON.parse(response.body)
    # # ...
    # else
    # # Handle the case when the API call was not successful
    #   puts "API call failed: #{response.code} - #{response.body}"
    # end

  end
end
