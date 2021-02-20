import { useState } from "react";
import firebase from "../services/firebase";

const useUser = () => {
  const [currentUser, setCurrentUser] = useState<
    firebase.User | null | undefined
  >(undefined);
};

export default useUser;
