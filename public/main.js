pusher = new Pusher("b470a1b48d9579a05f7f", {
  authEndpoint: "/auth-pusher",
  cluster: "us2",
});
pusher.connection.bind("error", function (err) {
  const e = err.error.data;
  console.log("Error %d: %s", e.code, e.message);
  //    console.log(err.error.data.code === 4004 ) {
});
pusher.connection.bind("state_change", function (states) {
  console.log("%s -> %s", states.previous, states.current);
});

// Initial data passed to Elm (should match `Flags` defined in `Shared.elm`)
// https://guide.elm-lang.org/interop/flags.html
var flags = null;

// Start our Elm application
var app = Elm.Main.init({ flags: flags });

// Ports go here
// https://guide.elm-lang.org/interop/ports.html
