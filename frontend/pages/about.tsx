import { useTranslation } from "react-i18next";
import { useContext, Suspense } from "react";
import styles from "../styles/Home.module.css";
import { AuthContext } from "../components/context/Auth";
import { useRouter } from "next/router";

const About = () => {
  const { currentUser } = useContext(AuthContext);
  const router = useRouter();

  if (!currentUser) {
    router.push("/");
    return <></>;
  }
  const [t] = useTranslation(["about", "common"]);

  return (
    <div className={styles.container}>
      <h1>{t("title")}</h1>
      {currentUser ? <div>{currentUser.displayName}</div> : <div>loading</div>}
    </div>
  );
};

const AboutWrapper = () => (
  <Suspense fallback="Loading">
    <About />
  </Suspense>
);
export default AboutWrapper;
