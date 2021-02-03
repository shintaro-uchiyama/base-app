import { useTranslation } from "react-i18next";
import { useContext } from "react";
import styles from "../styles/Home.module.css";
import { AuthContext } from "../components/context/Auth";
import { useRouter } from "next/router";
import { TFunction } from "next-i18next";

const About = () => {
  const { currentUser } = useContext(AuthContext);
  const router = useRouter();

  if (!currentUser) {
    router.push("/");
  }
  const [t] = useTranslation();

  return (
    <div className={styles.container}>
      <h1>{t("about:title")}</h1>
      <div>test {t("common:index.buttons.googleSignIn")}</div>
      {currentUser ? <div>{currentUser.displayName}</div> : <div>loading</div>}
    </div>
  );
};

export default About;
