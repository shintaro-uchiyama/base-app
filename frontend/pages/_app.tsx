import { AppProps } from "next/app";
import { ThemeProvider, CssBaseline, Grid } from "@material-ui/core";
import theme from "../components/theme";
import { AuthProvider } from "../context/Auth";
import "../i18n";

const MyApp = ({ Component, pageProps }: AppProps): JSX.Element => {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <AuthProvider>
        <Component {...pageProps} />
      </AuthProvider>
    </ThemeProvider>
  );
};

export default MyApp;
