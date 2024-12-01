import Link from "@docusaurus/Link"
import useDocusaurusContext from "@docusaurus/useDocusaurusContext"
import useBaseUrl from "@docusaurus/useBaseUrl"
import D2LogoUrl from "@site/static/D2.png"
import Layout from "@theme/Layout"
import clsx from "clsx"
import React from "react"
import styles from "./index.module.css"

function HomepageHeader() {
    const { siteConfig } = useDocusaurusContext()
    return (
        <header className={clsx("hero", styles.heroBanner)}>
            <div className="container">
                <img src={D2LogoUrl} alt="D2 Logo" className={styles.logo} />
                <p className="hero__subtitle">{siteConfig.tagline}</p>
                <div className={styles.buttons}>
                    <Link
                        className="button button--secondary button--lg"
                        to="/docs/intro"
                    >
                        Get Started with the D2 SDK
                    </Link>

                    <p>
                        <a href={useBaseUrl('/D2.rbxm')} >
                            or just download the module
                        </a>
                    </p>
                </div>
            </div>
        </header>
    )
}

export default function Home() {
    const { tagline } = useDocusaurusContext()
    return (
        <Layout description={tagline}>
            <HomepageHeader />
        </Layout>
    )
}