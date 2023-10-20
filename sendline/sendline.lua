-- Windower用のスクリプト

-- 依存ライブラリをロード
local http = require("socket.http")
local ltn12 = require("ltn12")

-- IFTTTのWebhook設定
local ifttt_key = "*************" -- ここにIFTTTのWebhookキーを設定
local event_name = "LINE_FFXI" -- ここにIFTTTで設定したイベント名を設定

--マッチング文字列　[]内はログのモード番号 検索は文字列の前後に.*を付けて正規表現を行う モード番号と文字列は1:1にはなっていない
local pattern_m = { 
	[148] = 'ビジタント消滅まで残り',
	[38]  = 'に倒された。',
--	[150] = 'クポ',--このへんはテスト用
--	[141] = 'クポ',
--	[127] = 'エミネンス',
	}

-- patternを生成
local patterns = {}
	for _, v in pairs(pattern_m) do
		table.insert(patterns, ".*" .. v .. ".*")
	end
local pattern = table.concat(patterns, "|")

-- permission_lookupを生成
local permission_lookup = {}
	for k, _ in pairs(pattern_m) do
   		permission_lookup[k] = true
	end

local message_queue = {}

-- incoming_textイベントハンドラを登録
windower.register_event("incoming text", function(original, modified, original_mode, modified_mode, blocked)

	--tell(mode:12)が来た時は内容に依らず送信(名前が文字化けするなぁ)
	if original_mode == 12 then
		local message = windower.from_shift_jis(original)
		message = message:gsub("\127\49", ""):gsub("%c", "")
		table.insert(message_queue, 'TELL from :' .. message) -- キューにメッセージを追加
	end

if permission_lookup[original_mode] then

-- オリジナルのテキストを取得
	local message = windower.from_shift_jis(original)

	message = message:gsub("\127\49", ""):gsub("%c", "")

	if windower.regex.match(message,pattern) then
		--print("Matched: " .. message) -- デバッグ用
		table.insert(message_queue, original_mode .. ':' .. message) -- キューにメッセージを追加

	end
end
end)

-- コルーチンでキューのメッセージを定期的に処理
coroutine.schedule(function()
	while true do
		if #message_queue > 0 then
			local message = table.remove(message_queue, 1) -- キューからメッセージを取り出し
			--print("Sending: " .. message) -- デバッグ用
			sendIFTTTWebHook(message)
		end
		coroutine.sleep(0.5) -- 0.5秒ごとにキューをチェック
	end
end, 0)

function sendIFTTTWebHook(message)

	-- データをJSON形式に変換
	local json_data = string.format('{"value1":"%s"}', message)
	--print(json_data)  -- デバッグ用
	--HTTPリクエストを構成
	url = "https://maker.ifttt.com/trigger/" .. event_name .. "/with/key/" .. ifttt_key
	headers = {
		["Content-Type"] = "application/json",
		["Content-Length"] = string.len(json_data)
		}

	-- HTTPリクエストを送信
	response = {}
	res, code, response_headers = http.request {
		url = url,
		method = "POST",
		headers = headers,
		source = ltn12.source.string(json_data),
		sink = ltn12.sink.table(response)
		}

--デバッグ用
--	if res and code == 200 then
--		print("Successfully sent: " .. message)
--	else
--	print("Failed to send: " .. message .. " with code: " .. (code or "nil"))
--	end

end
