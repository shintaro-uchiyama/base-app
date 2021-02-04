import { useTranslation } from "react-i18next";
import { Button } from "@material-ui/core";
import { FC } from "react";

interface GoogleSignInButtonProps {
  onClick: () => void;
}
const GoogleSignInButton: FC<GoogleSignInButtonProps> = (props) => {
  const [t] = useTranslation(["index"]);

  return (
    <Button
      variant="outlined"
      startIcon={
        <img alt="google icon" src="/google-icon.svg" width={18} height={18} />
      }
      onClick={props.onClick}
    >
      {t("buttons.signIn.google")}
    </Button>
  );
};

export default GoogleSignInButton;
