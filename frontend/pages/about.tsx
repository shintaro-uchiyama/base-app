import { useContext } from "react";
import styles from "../styles/Home.module.css";
import { AuthContext } from "../components/context/Auth";
import { withTranslation } from "../i18n";
import { useRouter } from "next/router";
import { TFunction } from "next-i18next";

interface AboutProps {
  t: TFunction;
}
const About = ({ t }: AboutProps) => {
  const { currentUser } = useContext(AuthContext);
  const router = useRouter();

  if (!currentUser) {
    router.push("/");
  }

  return (
    <div className={styles.container}>
      <h1>{t("about:title")}</h1>
      <div>test {t("common:index.buttons.googleSignIn")}</div>
      {currentUser ? <div>{currentUser.displayName}</div> : <div>loading</div>}
    </div>
  );
};

About.getInitialProps = async () => ({
  namespacesRequired: ["common", "about"],
});

export default withTranslation("about")(About);
