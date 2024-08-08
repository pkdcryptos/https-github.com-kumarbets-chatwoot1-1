// eslint-disable-next-line
function prepareData(data) {
  var labels = [];
  var dataSet = [];
  data.forEach(item => {
    labels.push(item[0]);
    dataSet.push(item[1]);
  });
  return { labels, dataSet };
}

function getChartOptions() {
  var fontFamily =
    'PlusJakarta,-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
  return {
    responsive: true,
    legend: { labels: { fontFamily } },
    scales: {
      xAxes: [
        {
          barPercentage: 1.26,
          ticks: { fontFamily },
          gridLines: { display: false },
        },
      ],
      yAxes: [
        {
          ticks: { fontFamily },
          gridLines: { display: false },
        },
      ],
    },
  };
}

