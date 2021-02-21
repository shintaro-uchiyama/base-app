import { useReducer, Reducer, Dispatch } from "react";
import firebase from "../services/firebase";

interface State {
  isAuthChecked: boolean;
  currentUser: firebase.User;
}

const ActionType = {
  Set: "set",
};

type ActionType = typeof ActionType[keyof typeof ActionType];

interface Action {
  type: ActionType;
  user: firebase.User;
}

const userReducer: Reducer<State, Action> = (state, action) => {
  switch (action.type) {
    case ActionType.Set:
      return {
        isAuthChecked: true,
        currentUser: action.user,
      };
    default:
      throw new Error(`expected action type not found, got ${action.type}`);
  }
};

export interface AuthHook {
  state: State;
  dispatch: Dispatch<Action>;
}

export const useUser = (): AuthHook => {
  const [state, dispatch] = useReducer(userReducer, {
    isAuthChecked: false,
    currentUser: null,
  });

  return { state, dispatch };
};
