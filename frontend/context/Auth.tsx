import { createContext, useEffect } from "react";
import { CircularProgress, Container, Grid } from "@material-ui/core";
import firebase from "../services/firebase";
import "firebase/auth";
import { useRouter } from "next/router";
import useUser from "../hooks/useUser";

interface AuthContextProps {
  currentUser: firebase.User;
}

const AuthContext = createContext<AuthContextProps>({ currentUser: null });

const AuthProvider = ({ children }) => {
  const { state, dispatch } = useUser();
  useEffect(() => {
    firebase.auth().onAuthStateChanged((user) => {
      dispatch({ type: "set", user });
    });
  }, []);

  const router = useRouter();
  if (state.isAuthChecked && !state.currentUser && router.pathname !== "/") {
    router.push("/");
    return <></>;
  }

  return (
    <>
      {state.isAuthChecked ? (
        <AuthContext.Provider value={{ currentUser: state.currentUser }}>
          {children}
        </AuthContext.Provider>
      ) : (
        <Grid container spacing={2}>
          <Grid item xs={12}>
            <Grid container alignItems="center" justify="center">
              <CircularProgress />
            </Grid>
          </Grid>
        </Grid>
      )}
    </>
  );
};

export { AuthContext, AuthProvider };
