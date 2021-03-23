import { useTranslation } from "react-i18next";
import { useContext, Suspense } from "react";
import styles from "../styles/Home.module.css";
import { AuthContext } from "../context/Auth";
import { CircularProgress } from "@material-ui/core";

const About = () => {
  const [t] = useTranslation(["about"]);

  const { state } = useContext(AuthContext);
  const { currentUser } = state;

  return (
    <div className={styles.container}>
      <h1>{t("title")}</h1>
      <div data-cy={"user-email"}>{currentUser.email}</div>
    </div>
  );
};

const AboutWrapper = () => (
  <Suspense fallback={<CircularProgress />}>
    <About />
  </Suspense>
);

export default AboutWrapper;
