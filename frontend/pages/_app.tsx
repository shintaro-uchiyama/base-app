import '../styles/globals.css'

import { AppProps } from 'next/app'

import { AuthProvider } from '../components/context/Auth'

const MyApp = ({ Component, pageProps }: AppProps): JSX.Element => {
  return (
      <AuthProvider>
        <Component {...pageProps} />
      </AuthProvider>
  )
}

export default MyApp