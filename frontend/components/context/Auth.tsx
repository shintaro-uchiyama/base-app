import { FC, createContext, useState } from "react";
import firebase from "../../hooks/firebase";
import "firebase/auth";
import { useRouter } from "next/router";

type AuthContextProps = {
  currentUser: firebase.User | null | undefined;
};

const AuthContext = createContext<AuthContextProps>({ currentUser: undefined });

const AuthProvider: FC = ({ children }) => {
  const [currentUser, setCurrentUser] = useState<
    firebase.User | null | undefined
  >(undefined);

  const [isAuthChecked, setIsAuthChecked] = useState(false);

  firebase.auth().onAuthStateChanged((user) => {
    setCurrentUser(user);
    setIsAuthChecked(true);
  });

  const router = useRouter();
  if (isAuthChecked && !currentUser && router.pathname !== "/") {
    router.push("/");
  }

  return (
    <div>
      {isAuthChecked ? (
        <AuthContext.Provider value={{ currentUser: currentUser }}>
          {children}
        </AuthContext.Provider>
      ) : (
        <div>Loading</div>
      )}
    </div>
  );
};

export { AuthContext, AuthProvider };
