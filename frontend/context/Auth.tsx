import { createContext, useEffect } from "react";
import { CircularProgress, Grid } from "@material-ui/core";
import firebase from "../services/firebase";
import "firebase/auth";
import { useRouter } from "next/router";
import { useUser, AuthHook, ActionType } from "../hooks/useUser";

const AuthContext = createContext<Partial<AuthHook>>({});

const AuthProvider = ({ children }) => {
  const { state, dispatch } = useUser(firebase.auth().currentUser);
  useEffect(() => {
    const unsubscribe = firebase.auth().onAuthStateChanged((user) => {
      dispatch({ type: ActionType.Set, user });
    });
    return () => {
      unsubscribe();
    };
  }, []);

  const router = useRouter();
  if (state.isAuthChecked && !state.currentUser && router.pathname !== "/") {
    router.push("/");
    return <></>;
  }

  return (
    <>
      {state.isAuthChecked ? (
        <AuthContext.Provider value={{ state, dispatch }}>
          {children}
        </AuthContext.Provider>
      ) : (
        <Grid container direction="column" alignItems="center" justify="center">
          <Grid item xs={3}>
            <CircularProgress />
          </Grid>
        </Grid>
      )}
    </>
  );
};

export { AuthContext, AuthProvider };
