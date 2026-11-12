return {
  "smart-splits-nvim/smart-splits.nvim",
  version = "^3.0.0",
  dependencies = { "rawnly/smart-splits-backend-rex" },
  opts = {
    move = { at_edge = "stop" },
    mux = {
      backend = "smart-splits-backend-rex",
      warn_if_unusable = false,
    },
  },
}
