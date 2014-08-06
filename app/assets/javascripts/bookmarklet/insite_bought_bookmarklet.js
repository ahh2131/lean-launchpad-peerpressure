function post(path, params, method) {
    method = method || "post"; // Set method to post by default if not specified.

    // The rest of this code assumes you are not using a library.
    // It can be made less wordy if you use one.
    var form = document.createElement("form");
    form.setAttribute("method", method);
    form.setAttribute("action", path);

    for(var key in params) {
        if(params.hasOwnProperty(key)) {
            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", key);
            hiddenField.setAttribute("value", params[key]);

            form.appendChild(hiddenField);
         }
    }

    document.body.appendChild(form);
    form.submit();
}


(function(){

  // Your simple bookmarklet code goes here.
  // For instance
  var url = encodeURIComponent(document.location);
  var html=document.documentElement.innerHTML;
  var iframe = document.getElementById('product-iframe');
  var iframeDocument = iframe.contentWindow.document;

  var found = html.search("complete")
  var found2 = html.search("receipt")
  if (found == -1 || found2 == -1) {
    purchased = -1
  }
  post('https://dev.vigme.com:3001/purchase/receipt', {html: iframeDocument, found: purchased, url: url});

  // alert('You just clicked the bought bookmarklet.');

})();
