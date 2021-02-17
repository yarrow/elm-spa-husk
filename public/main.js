// Initial data passed to Elm (should match `Flags` defined in `Shared.elm`)
// https://guide.elm-lang.org/interop/flags.html
var flags = null;

// Start our Elm application
var app = Elm.Main.init({ flags: flags });

// Ports go here
// https://guide.elm-lang.org/interop/ports.html
app.ports.connect.subscribe(() => {
  const pusher = new Pusher("b470a1b48d9579a05f7f", {
    authEndpoint: "/auth-pusher",
    cluster: "us2",
  });
  pusher.connection.bind("error", (err) => {
    const e = err?.error?.data;
    // Ignore errors that don't have an error.data field. Maybe should pass on
    // something like "Unknown error", but the case I know about is when
    // internet connection is lost, and in that case Pusher's state_change
    // captures the problem, changing from `connected` to `connecting` to
    // `unavailable`. (It does the reverse when connection is restored.)
    if (e) {
      app.ports.connectionError.send(JSON.stringify(e));
    }
  });
  pusher.connection.bind("state_change", (states) => {
    toElm("state_change", states);
  });
});

function toElm(tag, obj) {
  msg = `{"${tag}":${JSON.stringify(obj)}}`;
  console.log(msg);
}
