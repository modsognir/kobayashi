function getFlickrSets(username, userid, api) {
  $.getJSON("http://api.flickr.com/services/rest/?method=flickr.photosets.getList&api_key=" + api + "&page=1&per_page=4&user_id=" + userid + "&format=json&jsoncallback=?",
    function (data) {
      var list = $("<ul class='thumbnails'></ul>");
      $.each(data.photosets.photoset, function (i, set) {
        var link = $("<a />").attr("title", set.title._content)
            .attr("href", "http://www.flickr.com/photos/" + username + "/sets/" + set.id)
            .attr("class", "thumbnail");
        var img_src = $("<img />")
                      .attr("src", "http://farm" + set.farm + ".staticflickr.com/" + set.server + "/" + set.primary + "_" + set.secret + "_" + "m.jpg")
                      .attr("title", set.title._content)
                      .attr("alt", set.title._content);
        var img_link = $(link).append(img_src);
        var li = $('<li class="span3" />').append(img_link);
        $(list).append(li);
        });
      $("#flickr").append(list);
    }
)};

