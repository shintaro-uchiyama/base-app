import { AppProps } from "next/app";
import React from "react";
import { ThemeProvider } from "@material-ui/core/styles";
import CssBaseline from "@material-ui/core/CssBaseline";
import theme from "../components/theme";
import jpJson from "../public/locales/jp/translation.json";
import i18n from "i18next";
import { initReactI18next } from "react-i18next";

import { AuthProvider } from "../components/context/Auth";

const MyApp = ({ Component, pageProps }: AppProps): JSX.Element => {
  i18n.use(initReactI18next).init({
    resources: {
      jp: { translation: jpJson },
    },
    lng: "jp",
    fallbackLng: "jp",
    interpolation: { escapeValue: false },
  });

  React.useEffect(() => {
    // Remove the server-side injected CSS.
    const jssStyles = document.querySelector("#jss-server-side");
    if (jssStyles) {
      jssStyles.parentElement!.removeChild(jssStyles);
    }
  }, []);
  return (
    <ThemeProvider theme={theme}>
      {/* CssBaseline kickstart an elegant, consistent, and simple baseline to build upon. */}
      <CssBaseline />
      <AuthProvider>
        <Component {...pageProps} />
      </AuthProvider>
    </ThemeProvider>
  );
};

export default MyApp;
