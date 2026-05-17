pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import QtPositioning

import qs.modules.common

Singleton {
    id: root

    readonly property int fetchInterval: (Config.options.bar.weather.fetchInterval || 10) * 60 * 1000
    readonly property string city: Config.options.bar.weather.city
    readonly property bool useUSCS: Config.options.bar.weather.useUSCS
    property bool gpsActive: Config.options.bar.weather.enableGPS

    onUseUSCSChanged: root.getData()
    onCityChanged: root.getData()

    property var location: ({
        valid: false,
        lat: 0,
        lon: 0,
        cityName: ""
    })

    property var data: ({
        city: "City",
        temp: "0°",
        tempRaw: 0,
        tempFeelsLike: "0°",
        wCode: "113",
        description: "Clear",
        high: "0°",
        low: "0°",
        uv: 0,
        humidity: 0,
        wind: "0",
        precip: "0",
        precipProb: "0%",
        visib: "0",
        press: "0",
        sunrise: "00:00",
        sunset: "00:00",
        lastRefresh: "",
        hourly: [],
        daily: []
    })

    function mapWmoToWwo(wmoCode) {
        const mapping = {
            0: "113", 1: "116", 2: "116", 3: "119",
            45: "248", 48: "260",
            51: "266", 53: "266", 55: "284",
            56: "284", 57: "284",
            61: "296", 63: "302", 65: "308",
            66: "302", 67: "308",
            71: "326", 73: "332", 75: "338", 77: "326",
            80: "353", 81: "356", 82: "359",
            85: "368", 86: "371",
            95: "386", 96: "389", 99: "392"
        };
        return mapping[wmoCode] || "113";
    }

    function getWmoDescription(wmoCode) {
        const descriptions = {
            0: "Clear sky", 1: "Mainly clear", 2: "Partly cloudy", 3: "Overcast",
            45: "Fog", 48: "Depositing rime fog",
            51: "Light drizzle", 53: "Moderate drizzle", 55: "Dense drizzle",
            56: "Light freezing drizzle", 57: "Dense freezing drizzle",
            61: "Slight rain", 63: "Moderate rain", 65: "Heavy rain",
            66: "Light freezing rain", 67: "Heavy freezing rain",
            71: "Slight snow fall", 73: "Moderate snow fall", 75: "Heavy snow fall", 77: "Snow grains",
            80: "Slight rain showers", 81: "Moderate rain showers", 82: "Violent rain showers",
            85: "Slight snow showers", 86: "Heavy snow showers",
            95: "Thunderstorm", 96: "Thunderstorm with slight hail", 99: "Thunderstorm with heavy hail"
        };
        return descriptions[wmoCode] || "Unknown";
    }

    function refineData(raw) {
        if (!raw || !raw.current || !raw.daily || !raw.hourly) return;

        let refined = {};
        const current = raw.current;
        const daily = raw.daily;
        const hourly = raw.hourly;

        refined.city = root.gpsActive ? (root.location.cityName || "Current Location") : (root.city.split(',')[0].trim() || "City");
        refined.tempRaw = Math.round(current.temperature_2m);
        refined.temp = refined.tempRaw + "°";
        refined.tempFeelsLike = Math.round(current.apparent_temperature) + "°";
        refined.wCode = mapWmoToWwo(current.weather_code);
        refined.description = getWmoDescription(current.weather_code);

        refined.high = (daily.temperature_2m_max && daily.temperature_2m_max.length > 0) ? Math.round(daily.temperature_2m_max[0]) + "°" : "0°";
        refined.low = (daily.temperature_2m_min && daily.temperature_2m_min.length > 0) ? Math.round(daily.temperature_2m_min[0]) + "°" : "0°";

        refined.uv = Math.round(current.uv_index || 0);
        refined.humidity = Math.round(current.relative_humidity_2m) + "%";
        refined.wind = Math.round(current.wind_speed_10m) + (root.useUSCS ? " mph" : " km/h");
        refined.precip = current.precipitation + (root.useUSCS ? " in" : " mm");
        refined.precipProb = (daily.precipitation_probability_max && daily.precipitation_probability_max.length > 0) ? daily.precipitation_probability_max[0] + "%" : "0%";

        refined.sunrise = (daily.sunrise && daily.sunrise.length > 0) ? daily.sunrise[0].split("T")[1] : "00:00";
        refined.sunset = (daily.sunset && daily.sunset.length > 0) ? daily.sunset[0].split("T")[1] : "00:00";

        // Hourly (10 entries: Now + 9 hours)
        let hourlyData = [];
        const now = new Date();
        const currentHour = now.getHours();
        const todayStr = now.getFullYear() + "-" + String(now.getMonth() + 1).padStart(2, '0') + "-" + String(now.getDate()).padStart(2, '0');

        let startIndex = 0;
        for (let i = 0; i < hourly.time.length; i++) {
            if (hourly.time[i].startsWith(todayStr) && parseInt(hourly.time[i].split("T")[1].split(":")[0]) >= currentHour) {
                startIndex = i;
                break;
            }
        }

        for (let i = startIndex; i < startIndex + 10 && i < hourly.time.length; i++) {
            let hTime = hourly.time[i].split("T")[1];
            let hour = parseInt(hTime.split(":")[0]);
            let displayTime = String(hour).padStart(2, '0') + ":00";

            hourlyData.push({
                time: displayTime,
                icon: mapWmoToWwo(hourly.weather_code[i]),
                temp: Math.round(hourly.temperature_2m[i]) + "°",
                feels: Math.round(hourly.apparent_temperature[i]) + "°"
            });
        }
        refined.hourly = hourlyData;

        // Daily
        let dailyData = [];
        const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        for (let i = 0; i < daily.time.length && i < 6; i++) {
            let date = new Date(daily.time[i]);
            let dayName = i === 0 ? "Today" : days[date.getDay()];
            dailyData.push({
                day: dayName,
                icon: mapWmoToWwo(daily.weather_code[i]),
                min: Math.round(daily.temperature_2m_min[i]),
                max: Math.round(daily.temperature_2m_max[i])
            });
        }
        refined.daily = dailyData;

        refined.lastRefresh = DateTime.time + " • " + DateTime.date;
        root.data = refined;
    }

    function getData() {
        if (root.gpsActive && root.location.valid) {
            // Also update city name if using GPS
            reverseGeocoder.command = ["curl", "-s", "-A", "Quickshell-Weather", "https://nominatim.openstreetmap.org/reverse?format=json&lat=" + root.location.lat + "&lon=" + root.location.long + "&zoom=10"];
            reverseGeocoder.running = false;
            reverseGeocoder.running = true;
            fetchWeather(root.location.lat, root.location.long);
        } else if (root.city && root.city.length > 0) {
            let cleanCity = root.city.split(',')[0].trim();
            geocoder.command = ["curl", "-s", "https://geocoding-api.open-meteo.com/v1/search?name=" + cleanCity + "&count=1&language=en&format=json"];
            geocoder.running = false;
            geocoder.running = true;
        }
    }

    function fetchWeather(lat, lon) {
        let unit = root.useUSCS ? "fahrenheit" : "celsius";
        let windUnit = root.useUSCS ? "mph" : "kmh";
        let precipUnit = root.useUSCS ? "inch" : "mm";
        let url = "https://api.open-meteo.com/v1/forecast?latitude=" + lat + "&longitude=" + lon + "&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,wind_speed_10m,uv_index&hourly=temperature_2m,apparent_temperature,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_probability_max&temperature_unit=" + unit + "&wind_speed_unit=" + windUnit + "&precipitation_unit=" + precipUnit + "&timezone=auto";

        fetcher.command = ["curl", "-s", url];
        fetcher.running = false;
        fetcher.running = true;
    }

    Process {
        id: geocoder
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.length === 0) return;
                try {
                    const parsed = JSON.parse(text);
                    if (parsed.results && parsed.results.length > 0) {
                        const result = parsed.results[0];
                        fetchWeather(result.latitude, result.longitude);
                    }
                } catch (e) {}
            }
        }
    }

    Process {
        id: reverseGeocoder
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.length === 0) return;
                try {
                    const parsed = JSON.parse(text);
                    if (parsed.address) {
                        root.location.cityName = parsed.address.city || parsed.address.town || parsed.address.village || parsed.address.suburb || "";
                    }
                } catch (e) {}
            }
        }
    }

    Process {
        id: fetcher
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.length === 0) return;
                try {
                    const parsedData = JSON.parse(text);
                    root.refineData(parsedData);
                } catch (e) {}
            }
        }
    }

    PositionSource {
        id: positionSource
        active: root.gpsActive
        updateInterval: root.fetchInterval
        onPositionChanged: {
            if (position.latitudeValid && position.longitudeValid) {
                root.location.lat = position.coordinate.latitude;
                root.location.long = position.coordinate.longitude;
                root.location.valid = true;
                root.getData();
            }
        }
    }

    Timer {
        running: true
        repeat: true
        interval: root.fetchInterval
        triggeredOnStart: true
        onTriggered: root.getData()
    }
}
