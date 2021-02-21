import { FC, useContext, Suspense } from "react";
import Link from "next/link";
import { useTranslation } from "react-i18next";
import firebase from "../services/firebase";
import styles from "../styles/Home.module.css";
import { AuthContext } from "../context/Auth";
import GoogleSignInButton from "../components/atoms/GoogleSignInButton";
import { Grid, CircularProgress } from "@material-ui/core";

const Home: FC = () => {
  const [t] = useTranslation(["index"]);

  const { state } = useContext(AuthContext);
  const { currentUser } = state;

  const signIn = async () => {
    const provider = new firebase.auth.GoogleAuthProvider();
    await firebase.auth().signInWithRedirect(provider);
  };

  return (
    <Grid container>
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
  <Suspense fallback={<CircularProgress />}>
    <Home />
  </Suspense>
);
export default HomeWrapper;
