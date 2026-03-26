import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    react({
      // @ts-expect-error babel option type mismatch with @vitejs/plugin-react v6
      babel: {
        plugins: [["babel-plugin-react-compiler"]],
      },
    }),
  ],
});
