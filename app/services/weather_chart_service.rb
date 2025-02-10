class WeatherChartService
  CHART_URL = "https://image-charts.com/chart?"
  CHART_TYPE = "ls"
  CHART_SIZE = "400x200"
  CHART_AXIS = "x,y"
  CHART_COLORS = "FF0000,0000FF"
  CHART_LABEL_POSITION = "t"
  CHART_Y_RANGE = "-500,500"
  CHART_MARKERS = "o,FF0000,0,-1,5|o,0000FF,1,-1,5"

  def self.build_chart_url(forecast)
    dates = forecast["time"].map { |date| Date.parse(date).strftime("%m-%d") }.join("|")
    highs = forecast["temperature_2m_max"].join(",")
    lows = forecast["temperature_2m_min"].join(",")

    query_params = {
      cht: CHART_TYPE,
      chs: CHART_SIZE,
      chxt: CHART_AXIS,
      chd: "t:#{highs}|#{lows}",
      chxl: "0:|#{dates}",
      chco: CHART_COLORS,
      chdl: "Highs|Lows",
      chdlp: CHART_LABEL_POSITION,
      chds: CHART_Y_RANGE,
      chm: CHART_MARKERS
    }

    CHART_URL + URI.encode_www_form(query_params)
  end
end
