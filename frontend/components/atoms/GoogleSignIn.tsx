import styled from "styled-components";
import { useTranslation } from "react-i18next";
import { Button } from "@material-ui/core";

const GoogleIcon = styled.img`
  .google-icon {
    position: absolute;
    margin-top: 11px;
    margin-left: 11px;
    width: 18px;
    height: 18px;
  }
`;

const GoogleSignIn = () => {
  const [t] = useTranslation();

  return (
    <Button
      variant="outlined"
      startIcon={<img src="/google-icon.svg" width={18} height={18} />}
    >
      {t("index.buttons.googleSignIn")}
    </Button>
  );
};

export default GoogleSignIn;
