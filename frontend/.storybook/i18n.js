import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import jpJson from "../public/locales/jp/translation.json";

i18n.use(initReactI18next).init({
    resources: {
        jp: { translation: jpJson },
    },
    lng: "jp",
    fallbackLng: "jp",
    interpolation: { escapeValue: false },
});
export default i18n;