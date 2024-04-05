#!/usr/bin/env zsh

# need a `https://weatherapi.com/` API key
# go to https://www.weatherapi.com/signup.aspx and complete the form
# verify your email
# go to https://www.weatherapi.com/my/ and put the key in the code on the line that starts with API_KEY=

API_KEY=$WEATHER_API_KEY # insert api key here
location="$(curl -s ipinfo.io/loc)"

# first comment is description, second is icon number
weather_icons_day=(
    [1000]=   # Sunny/113
    [1003]=   # Partly cloudy/116
    [1006]=   # Cloudy/119
    [1009]=   # Overcast/122
    [1030]=   # Mist/143
    [1063]=   # Patchy rain possible/176
    [1066]=   # Patchy snow possible/179
    [1069]=   # Patchy sleet possible/182
    [1072]=   # Patchy freezing drizzle possible/185
    [1087]=   # Thundery outbreaks possible/200
    [1114]=   # Blowing snow/227
    [1117]=   # Blizzard/230
    [1135]=   # Fog/248
    [1147]=   # Freezing fog/260
    [1150]=   # Patchy light drizzle/263
    [1153]=   # Light drizzle/266
    [1168]=   # Freezing drizzle/281
    [1171]=   # Heavy freezing drizzle/284
    [1180]=   # Patchy light rain/293
    [1183]=   # Light rain/296
    [1186]=   # Moderate rain at times/299
    [1189]=   # Moderate rain/302
    [1192]=   # Heavy rain at times/305
    [1195]=   # Heavy rain/308
    [1198]=   # Light freezing rain/311
    [1201]=   # Moderate or heavy freezing rain/314
    [1204]=   # Light sleet/317
    [1207]=   # Moderate or heavy sleet/320
    [1210]=   # Patchy light snow/323
    [1213]=   # Light snow/326
    [1216]=   # Patchy moderate snow/329
    [1219]=   # Moderate snow/332
    [1222]=   # Patchy heavy snow/335
    [1225]=   # Heavy snow/338
    [1237]=   # Ice pellets/350
    [1240]=   # Light rain shower/353
    [1243]=   # Moderate or heavy rain shower/356
    [1246]=   # Torrential rain shower/359
    [1249]=   # Light sleet showers/362
    [1252]=   # Moderate or heavy sleet showers/365
    [1255]=   # Light snow showers/368
    [1258]=   # Moderate or heavy snow showers/371
    [1261]=   # Light showers of ice pellets/374
    [1264]=   # Moderate or heavy showers of ice pellets/377
    [1273]=   # Patchy light rain with thunder/386
    [1276]=   # Moderate or heavy rain with thunder/389
    [1279]=   # Patchy light snow with thunder/392
    [1282]=   # Moderate or heavy snow with thunder/395
)

weather_icons_night=(
    [1000]=  # Clear/113
    [1003]=  # Partly cloudy/116
    [1006]=  # Cloudy/119
    [1009]=  # Overcast/122
    [1030]=  # Mist/143
    [1063]=  # Patchy rain possible/176
    [1066]=  # Patchy snow possible/179
    [1069]=  # Patchy sleet possible/182
    [1072]=  # Patchy freezing drizzle possible/185
    [1087]=  # Thundery outbreaks possible/200
    [1114]=  # Blowing snow/227
    [1117]=  # Blizzard/230
    [1135]=  # Fog/248
    [1147]=  # Freezing fog/260
    [1150]=  # Patchy light drizzle/263
    [1153]=  # Light drizzle/266
    [1168]=  # Freezing drizzle/281
    [1171]=  # Heavy freezing drizzle/284
    [1180]=  # Patchy light rain/293
    [1183]=  # Light rain/296
    [1186]=  # Moderate rain at times/299
    [1189]=  # Moderate rain/302
    [1192]=  # Heavy rain at times/305
    [1195]=  # Heavy rain/308
    [1198]=  # Light freezing rain/311
    [1201]=  # Moderate or heavy freezing rain/314
    [1204]=  # Light sleet/317
    [1207]=  # Moderate or heavy sleet/320
    [1210]=  # Patchy light snow/323
    [1213]=  # Light snow/326
    [1216]=  # Patchy moderate snow/329
    [1219]=  # Moderate snow/332
    [1222]=  # Patchy heavy snow/335
    [1225]=  # Heavy snow/338
    [1237]=  # Ice pellets/350
    [1240]=  # Light rain shower/353
    [1243]=  # Moderate or heavy rain shower/356
    [1246]=  # Torrential rain shower/359
    [1249]=  # Light sleet showers/362
    [1252]=  # Moderate or heavy sleet showers/365
    [1255]=  # Light snow showers/368
    [1258]=  # Moderate or heavy snow showers/371
    [1261]=  # Light showers of ice pellets/374
    [1264]=  # Moderate or heavy showers of ice pellets/377
    [1273]=  # Patchy light rain with thunder/386
    [1276]=  # Moderate or heavy rain with thunder/389
    [1279]=  # Patchy light snow with thunder/392
    [1282]=  # Moderate or heavy snow with thunder/395
)

function get_day {
    local weather_info
    weather_info="$1"
    condition_code=$(echo "$weather_info" | jq -r '.condition.code')
    condition_text=$(echo "$weather_info" | jq -r '.condition.text')
    maxtemp=$(echo "$weather_info" | jq -r '.maxtemp_c')
    mintemp=$(echo "$weather_info" | jq -r '.mintemp_c')
    avgtemp=$(echo "$weather_info" | jq -r '.avgtemp_c')
    daily_chance_of_rain=$(echo "$weather_info" | jq -r '.daily_chance_of_rain')
    daily_chance_of_snow=$(echo "$weather_info" | jq -r '.daily_chance_of_snow')
    icon=${weather_icons_day[$condition_code]}
    label="$condition_text ${mintemp}°C~${maxtemp}°C, 平均${avgtemp}°C"
    ((daily_chance_of_rain > 0)) && label="$label, 降雨概率 ${daily_chance_of_rain}%"
    ((daily_chance_of_snow > 0)) && label="$label, 下雪概率 ${daily_chance_of_snow}%"
}

function get_label {
    local weather_info
    weather_info="$1"
    condition_code=$(echo "$weather_info" | jq -r '.condition.code')
    condition_text=$(echo "$weather_info" | jq -r '.condition.text')
    temp=$(echo "$weather_info" | jq -r '.temp_c')
    fellslike=$(echo "$weather_info" | jq -r '.feelslike_c')
    humidity=$(echo "$weather_info" | jq -r '.humidity')
    is_day=$(echo "$weather_info" | jq -r '.is_day')
    chance_of_rain=$(echo "$weather_info" | jq -r 'if .chance_of_rain == null then 0 else .chance_of_rain end')
    chance_of_snow=$(echo "$weather_info" | jq -r 'if .chance_of_snow == null then 0 else .chance_of_snow end')
    ((is_day == 1)) && icon=${weather_icons_day[$condition_code]} || icon=${weather_icons_night[$condition_code]}
    label="$condition_text ${temp}°C 体感 ${fellslike}°C"
    echo "降雨概率: $chance_of_rain"
    ((chance_of_rain > 0)) && label="$label, 降雨概率 ${chance_of_rain}%"
    ((chance_of_snow > 0)) && label="$label, 下雪概率 ${chance_of_snow}%"
}

function update_weather {
    data=$(curl -s "http://api.weatherapi.com/v1/forecast.json?key=$API_KEY&q=$location&lang=zh&days=2")
    today_date=$(date +%F)
    tomorrow_date=$(date -v +1d +%F)
    check_in_time="09:00"

    today_data=$(echo "$data" | jq -r ".forecast.forecastday[]|select(.date==\"$today_date\")|.day")
    get_day "$today_data"
    sketchybar --set weather.today icon="$icon" label="今天 $label"

    (($(date +%u) == 5)) && check_out_time="20:00" || check_out_time="22:00"
    current_data=$(echo "$data" | jq -r '.current')
    get_label "$current_data"
    sketchybar --set weather icon="$icon" label="${temp}°C"
    sketchybar --set weather.current icon="$icon" label="当前 $label"

    today2_data=$(echo "$data" | jq -r ".forecast.forecastday[]|select(.date==\"$today_date\")|.hour[]|select(.time==\"$today_date $check_out_time\")")
    get_label "$today2_data"
    sketchybar --set weather.today2 icon="$icon" label="今晚 $label"

    tomorrow_data=$(echo "$data" | jq -r ".forecast.forecastday[]|select(.date==\"$tomorrow_date\")|.day")
    get_day "$tomorrow_data"
    sketchybar --set weather.tomorrow icon="$icon" label="明天 $label"

    (($(date +%u) == 4)) && check_out_time="20:00" || check_out_time="22:00"
    tomorrow1_data=$(echo "$data" | jq -r ".forecast.forecastday[]|select(.date==\"$tomorrow_date\")|.hour[]|select(.time==\"$tomorrow_date $check_in_time\")")
    get_label "$tomorrow1_data"
    sketchybar --set weather.tomorrow1 icon="$icon" label="明早 $label"

    tomorrow2_data=$(echo "$data" | jq -r ".forecast.forecastday[]|select(.date==\"$tomorrow_date\")|.hour[]|select(.time==\"$tomorrow_date $check_out_time\")")
    get_label "$tomorrow2_data"
    sketchybar --set weather.tomorrow2 icon="$icon" label="明晚 $label"
}

case "$SENDER" in
"mouse.clicked")
    sketchybar --set "$NAME" popup.drawing=toggle #Inactive
    ;;
"mouse.exited" | "mouse.exited.global")
    sketchybar --set "$NAME" popup.drawing=off #Inactive
    ;;
*)
    update_weather
    ;;
esac
