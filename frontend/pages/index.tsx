import { FC, useContext } from "react";
import firebase from "../hooks/firebase";
import Head from "next/head";
import styles from "../styles/Home.module.css";
import { AuthContext } from "../components/context/Auth";
import GoogleSignIn from "../components/atoms/GoogleSignIn";

const Home: FC = () => {
  const { currentUser } = useContext(AuthContext);
  firebase
    .auth()
    .getRedirectResult()
    .then((result) => {
      console.log("result: ", result);
      if (result.credential) {
        /** @type {firebase.auth.OAuthCredential} */
        const credential = result.credential;

        // This gives you a Google Access Token. You can use it to access the Google API.
        const token = credential.toJSON();
        console.log("success: ", credential, token);
        // ...
      }
      // The signed-in user info.
      const user = result.user;
    })
    .catch((error) => {
      // Handle Errors here.
      const errorCode = error.code;
      const errorMessage = error.message;
      // The email of the user's account used.
      const email = error.email;
      // The firebase.auth.AuthCredential type that was used.
      const credential = error.credential;
      // ...
      console.log("fail: ", errorCode, errorMessage, credential);
    });
  const login = () => {
    const provider = new firebase.auth.GoogleAuthProvider();
    firebase.auth().signInWithRedirect(provider);
  };
  return (
    <div className={styles.container}>
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
        <h1 className={styles.title}>Good Morning, World!</h1>

        <GoogleSignIn />
      </main>
    </div>
  );
};

export default Home;
