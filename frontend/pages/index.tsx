import { FC, useContext, Suspense } from "react";
import Link from "next/link";
import { useTranslation } from "react-i18next";
import firebase from "../services/firebase";
import Head from "next/head";
import styles from "../styles/Home.module.css";
import { AuthContext } from "../context/Auth";
import GoogleSignInButton from "../components/atoms/GoogleSignInButton";
import { Grid } from "@material-ui/core";

const Home: FC = () => {
  const { currentUser } = useContext(AuthContext);

  const signIn = async () => {
    const provider = new firebase.auth.GoogleAuthProvider();
    await firebase.auth().signInWithRedirect(provider);
  };
  const [t] = useTranslation(["index"]);
  return (
    <Grid container>
      <link
        rel="stylesheet"
        type="text/css"
        href="//fonts.googleapis.com/css?family=Open+Sans"
      />

      <Head>
        <title>Create Next App</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>{t("title")}</h1>
        {currentUser ? (
          <Link href="/about">
            <a>{t("buttons.about")}</a>
          </Link>
        ) : (
          <GoogleSignInButton onClick={signIn} />
        )}
      </main>
    </Grid>
  );
};

const HomeWrapper = () => (
  <Suspense fallback="loading">
    <Home />
  </Suspense>
);
export default HomeWrapper;
