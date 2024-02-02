document
  .getElementById("resourceForm")
  .addEventListener("submit", function (event) {
    event.preventDefault();

    var title = document.getElementById("title").value;
    var url = document.getElementById("url").value;
    var description = document.getElementById("description").value;
    var thumbnail = document.getElementById("thumbnail").value;
    var publishedDate = document.getElementById("publishedDate").value;
    var channelName = document.getElementById("channelName").value;
    var toolRelatedTo = document.getElementById("toolRelatedTo").value;

    if (
      !title ||
      !url ||
      !description ||
      !thumbnail ||
      !publishedDate ||
      !channelName ||
      !toolRelatedTo
    ) {
      alert("All fields are required.");
      return;
    }

    var urlRegex = /^(ftp|http|https):\/\/[^ "]+$/;
    if (!urlRegex.test(url) || !urlRegex.test(thumbnail)) {
      alert("Please enter valid URLs.");
      return;
    }

    var currentDate = new Date();
    var inputDate = new Date(publishedDate);
    if (inputDate > currentDate) {
      alert("Published date cannot be in the future.");
      return;
    }

    this.submit();
  });
