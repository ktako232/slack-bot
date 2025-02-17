require "roo"
require "open-uri"
require "nokogiri"
require "httparty"   # HackMDのページ取得に利用
require "slack-ruby-client"

# --- Slackクライアントの設定 ---
Slack.configure do |config|
  # APIトークンは環境変数等から取得してください
  config.token = ENV["SLACK_API_TOKEN"]
end
slack_client = Slack::Web::Client.new

# --- HackMDから掃除当番の名前を抜き出す関数 ---
def extract_cleaning_name(selector)
  # HackMDのページURL（適宜変更してください）
  url = "https://hackmd.io/@-hJEldZWQXeHzNQiqAjRcw/S1bzTHXvq"
  response = HTTParty.get(url)
  if response.code != 200
    puts "HackMD ページの取得に失敗しました: #{response.code}"
    return nil
  end
  doc = Nokogiri::HTML(response.body)
  
  # 指定されたCSSセレクタで要素を抽出
  element = doc.at_css(selector)
  if element
    # 取得したテキストから前後の空白を削除
    name = element.text.strip
    return name
  else
    puts "指定のセレクタ(#{selector}) で要素が見つかりませんでした。"
    return nil
  end
end

# --- Excelファイルへの接続 ---  
# Excelファイルのパスを指定（例："data.xlsx"）
workbook = Roo::Excelx.new("data.xlsx")
worksheet = workbook.sheet(0)  # 最初のシートを利用

# --- メイン処理 ---
# Excelの場合、A列は列番号1、B列は列番号2とする
start_row = 441
last_row  = worksheet.last_row  # Excelシートの最終行番号

(start_row..last_row).each do |row_index|
  # A列（1列目）の値を取得
  cell_a = worksheet.cell(row_index, 1)
  # セルが nil または空文字ならスキップ
  next if cell_a.nil? || cell_a.to_s.strip.empty?

  # B列（2列目）の値を取得
  cell_b = worksheet.cell(row_index, 2)
  
  # B列が "Skip"（大文字小文字問わず）でなければ処理する
  unless cell_b.to_s.strip.downcase == "skip"
    # HackMDから掃除当番の名前を抜き出す（例：CSSセレクタ ".cleaning-name" を指定）
    cleaning_name = extract_cleaning_name(".cleaning-name")
    
    if cleaning_name && !cleaning_name.empty?
      # 名前の前に @ を付けた文字列を作成
      slack_message = "@#{cleaning_name}"
      
      # Slackに投稿する（チャンネル名は適宜変更）
      begin
        slack_client.chat_postMessage(channel: "#bot-test", text: slack_message, as_user: true)
        puts "行 #{row_index} の掃除当番 #{slack_message} を投稿しました。"
      rescue => e
        puts "Slackへの投稿に失敗しました: #{e.message}"
      end
    else
      puts "行 #{row_index} で掃除当番の名前が取得できませんでした。"
    end
  else
    puts "行 #{row_index} は B列が 'Skip' のためスキップ。"
  end
end