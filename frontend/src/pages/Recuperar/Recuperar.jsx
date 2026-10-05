import { useState } from "react";
import { Link } from "react-router-dom";
import { obtenerUsuarios } from "../../utils/users";
import BrandLogo from "../../components/BrandLogo/BrandLogo";
import "../Login/Login.css";

function Recuperar() {
    const [cedula, setCedula] = useState("");
    const [mensaje, setMensaje] = useState("");
    const [error, setError] = useState("");

    const handleSubmit = (e) => {
        e.preventDefault();

        const usuarios = obtenerUsuarios();
        const usuario = usuarios.find(
            (item) => String(item.cedula) === String(cedula).trim()
        );

        if (!usuario) {
            setError("No encontramos una cuenta con esa cédula.");
            setMensaje("");
            return;
        }

        setError("");
        setMensaje(`Se enviaron las instrucciones de recuperación a ${usuario.correo || "tu correo institucional"}. Revisa tu bandeja de entrada.`);
    };

    return (
        <div className="login">
            <aside className="login__aside">
                <div className="login__orb login__orb--tr" aria-hidden="true">
                    <span className="login__orb-dot" />
                </div>
                <div className="login__orb login__orb--bl" aria-hidden="true">
                    <span className="login__orb-dot" />
                </div>
                <div className="login__aside-inner">
                    <BrandLogo
                        className="login__logo"
                        alt="UniAJS - Corporación Universitaria Antonio José de Sucre"
                    />

                    <h1 className="login__title">
                        Recupera el<br />
                        acceso a tu<br />
                        cuenta
                    </h1>
                    <p className="login__desc">
                        Te enviaremos las instrucciones para restablecer tu contraseña a tu correo institucional.
                    </p>
                </div>
            </aside>

            <section className="login__panel">
                <div className="login__card">
                    <div className="login__form-header">
                        <h2>Recuperar acceso</h2>
                        <p>Ingresa tu número de cédula para continuar</p>
                    </div>

                    {error && (
                        <div className="login__error" role="alert">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <circle cx="12" cy="12" r="10"/>
                                <line x1="12" y1="8" x2="12" y2="12"/>
                                <line x1="12" y1="16" x2="12.01" y2="16"/>
                            </svg>
                            <span>{error}</span>
                        </div>
                    )}

                    {mensaje && (
                        <div className="login__success" role="alert">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                                <polyline points="22 4 12 14.01 9 11.01"/>
                            </svg>
                            <span>{mensaje}</span>
                        </div>
                    )}

                    <form onSubmit={handleSubmit} className="login__form" autoComplete="off">
                        <div className="login__field">
                            <label htmlFor="recuperar-cedula">Cédula</label>
                            <input
                                type="text"
                                id="recuperar-cedula"
                                placeholder="Número de cédula"
                                value={cedula}
                                onChange={(e) => setCedula(e.target.value)}
                                required
                                inputMode="numeric"
                                pattern="[0-9]*"
                            />
                        </div>

                        <button type="submit" className="login__submit" disabled={!cedula}>
                            Enviar instrucciones
                        </button>
                    </form>

                    <div className="login__back-link">
                        <Link to="/login">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <line x1="19" y1="12" x2="5" y2="12"/>
                                <polyline points="12 19 5 12 12 5"/>
                            </svg>
                            Volver al inicio de sesión
                        </Link>
                    </div>
                </div>
            </section>
        </div>
    );
}

export default Recuperar;
